package main

import (
	"fmt"
	"log"

	"github.com/bruceherve/fiber-tutorial/book"
	"github.com/bruceherve/fiber-tutorial/book/database"
	"github.com/gofiber/fiber/v2"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

/*func helloworld(c *fiber.Ctx) error {
	return c.SendString("Hello, world!")
}*/

func setupRoutes(app *fiber.App) {
	app.Get("/api/v1/book", book.GetBooks)
	app.Get("/api/v1/book/:id", book.GetBook)
	app.Post("/api/v1/book", book.NewBook)
	app.Delete("/api/v1/book/:id", book.DeleteBook)
}

func initDatabase() {
	var err error
	database.DBConn, err = gorm.Open(sqlite.Open("books.db"), &gorm.Config{})

	if err != nil {
		panic("failed to connect to database")
	}
	fmt.Println("Databse successfully opened")
	database.DBConn.AutoMigrate(&book.Book{})
	fmt.Println("Database Migrated")
}

func main() {
	app := fiber.New()
	//initialize database
	initDatabase()
	setupRoutes(app)

	log.Fatal(app.Listen(":3000"))

}
