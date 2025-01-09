package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5"
)

type PostgresConfig struct {
	User     string
	Password string
	URL      string
	DB       string
	PORT     string
}

func main() {
	config := PostgresConfig{
		User:     os.Getenv("POSTGRES_USER"),
		Password: os.Getenv("POSTGRES_PASSWORD"),
		URL:      os.Getenv("POSTGRES_URL"),
		DB:       os.Getenv("POSTGRES_DB"),
		PORT:     os.Getenv("POSTGRES_PORT"),
	}

	connString := "postgres://" + config.User + ":" + config.Password + "@" + config.URL + ":" + config.PORT + "/" + config.DB
	conn, err := pgx.Connect(context.Background(), connString)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}

	defer dbCleanupTable(conn)

	fmt.Println("Connected to database successfully")

	cleanupDone := make(chan struct{})
	defer close(cleanupDone)

	go dbHandleInterruptSignal(conn, cleanupDone)

	dbEnsureTableExists(conn)

	iterations, workers := getEnvVars()

	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	dbBench(conn, rnd, iterations, workers)
}

func dbEnsureTableExists(conn *pgx.Conn) {
	query := `
        CREATE TABLE IF NOT EXISTS pgbench_test_table (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT NOW()
        );
    `
	_, err := conn.Exec(context.Background(), query)
	if err != nil {
		log.Fatalf("Failed to ensure table exists: %v\n", err)
	}
	fmt.Println("Table pgbench_test_table exists or was created")
}

func dbCleanupTable(conn *pgx.Conn) {
	query := "DROP TABLE IF EXISTS example_table;"
	_, err := conn.Exec(context.Background(), query)
	if err != nil {
		log.Printf("Failed to cleanup table: %v\n", err)
	} else {
		fmt.Println("Table dropped successfully.")
	}

	err = conn.Close(context.Background())
	if err != nil {
		log.Printf("Failed to close database connection: %v\n", err)
	} else {
		fmt.Println("Database connection closed successfully.")
	}
}

func dbHandleInterruptSignal(conn *pgx.Conn, cleanupDone chan struct{}) {
	signalChan := make(chan os.Signal, 1)
	signal.Notify(signalChan, os.Interrupt, syscall.SIGTERM)

	<-signalChan
	fmt.Println("\nInterrupt signal received. Cleaning up...")

	dbCleanupTable(conn)

	close(cleanupDone)
}

func getEnvVars() (iterations, workers int) {
	iterationsStr := os.Getenv("ITERATIONS")
	iterations = 100
	if iterationsStr != "" {
		iterationsParsed, err := strconv.Atoi(iterationsStr)
		if err != nil || iterationsParsed <= 0 {
			log.Printf("Invalid ITERATIONS value (%s), defaulting to 100\n", iterationsStr)
		} else {
			iterations = iterationsParsed
		}
	}

	workersStr := os.Getenv("WORKERS")
	workers = 4
	if workersStr != "" {
		workersParsed, err := strconv.Atoi(workersStr)
		if err != nil || workersParsed <= 0 {
			log.Printf("Invalid WORKERS value (%s), defaulting to 4\n", workersStr)
		} else {
			workers = workersParsed
		}
	}

	return
}

func dbBench(conn *pgx.Conn, rnd *rand.Rand, iterations, workers int) {
	tasks := make(chan int, iterations)
	done := make(chan struct{})

	connString := conn.Config().ConnString()

	for w := 1; w <= workers; w++ {
		go dbWorkerWithConnection(connString, rnd, tasks, done, w)
	}

	for i := 1; i <= iterations; i++ {
		tasks <- i
	}
	close(tasks)

	for i := 1; i <= workers; i++ {
		<-done
	}

	fmt.Println("All tasks completed.")
}

func dbWorkerWithConnection(connString string, rnd *rand.Rand, tasks <-chan int, done chan<- struct{}, workerID int) {
	conn, err := pgx.Connect(context.Background(), connString)
	if err != nil {
		log.Fatalf("Worker %d: Failed to connect to database: %v\n", workerID, err)
	}
	defer func() {
		err := conn.Close(context.Background())
		if err != nil {
			log.Printf("Worker %d: Failed to close database connection: %v\n", workerID, err)
		} else {
			fmt.Printf("Worker %d: Database connection closed.\n", workerID)
		}
	}()

	for task := range tasks {
		if rnd.Intn(2) == 0 {
			fmt.Printf("Worker %d: Task %d - Running SELECT example\n", workerID, task)
			dbSelect(conn)
		} else {
			fmt.Printf("Worker %d: Task %d - Running INSERT example\n", workerID, task)
			dbInsert(conn, rnd)
		}
	}
        offsetStr := os.Getenv("OFFSET_MILLISECONDS")
        offsetMilliseconds := 0
        if offsetStr != "" {
                offsetParsed, err := strconv.Atoi(offsetStr)
                if err != nil || offsetParsed < 0 {
                        log.Printf("Invalid OFFSET_MILLISECONDS value (%s), defaulting to 0\n", offsetStr)
                } else {
                        offsetMilliseconds = offsetParsed
                }
        }
        time.Sleep(time.Duration(offsetMilliseconds) * time.Millisecond)

	fmt.Printf("Worker %d completed all tasks.\n", workerID)
	done <- struct{}{}
}

func dbSelect(conn *pgx.Conn) {
	query := "SELECT id, name FROM pgbench_test_table LIMIT 10"
	rows, err := conn.Query(context.Background(), query)
	if err != nil {
		log.Fatalf("Query failed: %v\n", err)
	}
	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		err := rows.Scan(&id, &name)
		if err != nil {
			log.Fatalf("Row scan failed: %v\n", err)
		}
	}
}

func dbInsert(conn *pgx.Conn, rnd *rand.Rand) {
	query := "INSERT INTO pgbench_test_table (name, created_at) VALUES ($1, $2)"
	name := fmt.Sprintf("User%d", rnd.Intn(1000))
	createdAt := time.Now()
	_, err := conn.Exec(context.Background(), query, name, createdAt)
	if err != nil {
		log.Printf("Insert failed: %v\n", err)
		return
	}
}
