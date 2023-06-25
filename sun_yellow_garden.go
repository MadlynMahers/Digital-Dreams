package DigitalDreams

import "fmt"

func main() {
//1
	fmt.Println("We are living in a digital world")
	
//2
	var answer string
	fmt.Print("What do you dream of? ")
	fmt.Scan(&answer)
	fmt.Println("You dream of", answer)
	
//3
	var arr = []string{"Robots", "AI", "3D printing"}
	for _, element := range arr {
		fmt.Println(element)
	}
	
//4
	var sum int 
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)
	
//5
	type product struct {
		name string
		price float64
	}
	
	var tablet product
	tablet.name = "Tablet Pro X"
	tablet.price = 2000
	
	fmt.Printf("The %s costs %.2f\n", tablet.name, tablet.price)
	
//6
	num := 5
	if num < 6 {
		fmt.Println("The number is smaller than 6")
	}
	
//7
	switch num {
		case 0:
			fmt.Println("Number is 0")
		case 5:
			fmt.Println("Number is 5")
		default:
			fmt.Println("Number is some other value")
	}
	
//8
	var ch = make(chan string)
	go func() {
		ch <- "Digital"
		ch <- "Dreams"
		close(ch)
	}()
	
	for v := range ch {
		fmt.Println(v)
	}
	
//9
	fmt.Println("Creating a new file...")
	f, err := os.Create("DigitalDreams.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f.Close()

//10
	var data = "Let's build something amazing"
	_, err = f.WriteString(data)
	if err != nil {
		fmt.Println(err)
		f.Close()
		return
	}
	
//11
	err = json.NewEncoder(f).Encode(tablet)
	if err != nil {
		fmt.Println(err)
		return
	}
	
//12
	fmt.Println("Writing to a file...")
	f2, err := os.Open("DigitalDreams.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f2.Close()
	
//13
	var tablet2 product
	err = json.NewDecoder(f2).Decode(&tablet2)
	if err != nil {
		fmt.Println(err)
		return
	}
	
//14
	fmt.Println(tablet2)
	
//15
	fmt.Println("Saving data to database...")
	db, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()

//16
	_, err = db.Exec("INSERT INTO products (name, price) VALUES ($1,$2)", tablet2.name, tablet2.price)
	if err != nil {
		fmt.Println(err)
		return
	}
	
//17
	rows, err := db.Query("SELECT * FROM products")
	if err != nil {
		fmt.Println(err)
		return
	}

//18
	for rows.Next() {
		var name string
		var price float64
		err = rows.Scan(&name, &price)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println(name, price)
	}

//19
	fmt.Println("Running digital dreams server...")
	http.HandleFunc("/", digitalDreams)
	err = http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println(err)
	}
	
//20
	fmt.Println("Welcome to the world of digital dreams!")
}

func digitalDreams(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to Digital Dreams!")
}