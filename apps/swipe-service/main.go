package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/brianvoe/gofakeit/v7"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Swipe struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Swiper    uint      `json:"swiper" gorm:"uniqueIndex:idx_swiper_swiped"`
	Swiped    uint      `json:"swiped" gorm:"uniqueIndex:idx_swiper_swiped"`
	Matched   bool      `json:"matched" gorm:"default:false"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type User struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name"`
	Email     string    `json:"email" gorm:"uniqueIndex"`
	Picture   string    `json:"picture" gorm:"type:text"`
	Latitude  float64   `json:"latitude" gorm:"not null"`
	Longitude float64   `json:"longitude" gorm:"not null"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

var db *gorm.DB

func OpenDbConnect() {
	var err error

	// CockroachDB connection string
	dsn := "postgresql://root@localhost:26257/defaultdb?sslmode=disable"
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(fmt.Sprintf("failed to connect to CockroachDB: %v", err))
	}
}

func main() {
	var command string
	if len(os.Args) > 1 {
		command = os.Args[1]

		switch command {
		case "seed":
			Seed()
			return
		case "migrate":
			Migrate()
			return
		}
	}

	OpenDbConnect()

	r := gin.Default()

	r.GET("/swipes", GetSwipes)
	r.POST("/swipes", CreateSwipe)

	r.Run(":8081")
}

func Migrate() {
	OpenDbConnect()

	db.AutoMigrate(&Swipe{})
	db.AutoMigrate(&User{})
}

func Seed() {
	OpenDbConnect()

	rand.Seed(time.Now().UnixNano())
	gofakeit.Seed(time.Now().UnixNano())

	const totalUsers = 1_000_000

	start := time.Now()

	for i := 1; i <= totalUsers; i++ {
		u := User{
			Name:      gofakeit.Name(),
			Email:     fmt.Sprintf("user%d@example.com", i), // unique
			Latitude:  randomBrazilLat(),
			Longitude: randomBrazilLon(),
		}

		if err := db.Create(&u).Error; err != nil {
			fmt.Printf("Could not insert user %d: %v\n", i, err)
			continue
		}

		// Optional: print progress every 1000 users
		if i%1000 == 0 {
			fmt.Printf("Inserted %d users\n", i)
		}
	}

	fmt.Printf("✅ Finished seeding %d users in %v\n", totalUsers, time.Since(start))
}

// Helper functions to generate random lat/lon inside Brazil
func randomBrazilLat() float64 {
	latMin, latMax := -33.75, 5.27
	return latMin + rand.Float64()*(latMax-latMin)
}

func randomBrazilLon() float64 {
	lonMin, lonMax := -73.99, -34.79
	return lonMin + rand.Float64()*(lonMax-lonMin)
}

func GetSwipes(c *gin.Context) {
	var swipes []Swipe
	db.Find(&swipes)
	c.JSON(http.StatusOK, swipes)
}

func CreateSwipe(c *gin.Context) {
	var swipe Swipe

	if err := c.ShouldBindJSON(&swipe); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if swipe.Swiped == swipe.Swiper {
		c.JSON(http.StatusBadRequest, "Swiper cannot be the same as the swiped.")
		return
	}

	result := db.Create(&swipe)
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, "Error while creating swipe")
		return
	}

	c.JSON(http.StatusCreated, swipe)
}
