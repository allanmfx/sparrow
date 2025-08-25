package main

import (
	"fmt"
	"net/http"
	"time"

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

var db *gorm.DB

func main() {
	var err error

	// CockroachDB connection string
	dsn := "postgresql://root@localhost:26257/defaultdb?sslmode=disable"
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(fmt.Sprintf("failed to connect to CockroachDB: %v", err))
	}

	// Auto-migrate the schema
	db.AutoMigrate(&Swipe{})

	r := gin.Default()

	r.GET("/swipes", GetSwipes)
	r.POST("/swipes", CreateSwipe)

	r.Run(":8081")
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
