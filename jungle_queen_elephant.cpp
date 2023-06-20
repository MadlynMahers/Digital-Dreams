#include<iostream> //includes libraries used for basic I/O operations
#include<string> //includes libraries used for string manipulation
 
using namespace std; //to avoid adding 'std' prefix to every library function 
				     //used in the program
 
int main(){ 
	
	//creating a string to store our digital dream
    string dream=""; //string can contain anything like characters, numbers, etc.
 
 	//loop to iterate 1000 times
    for(int i=0;i<1000;i++){ 
 
 		//appending a character each time to the string
        dream +="D"; 
    }
 
 	//printing the created string
    cout << dream << endl; //output : DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
 
    return 0; //returns 0 to indicate successful program execution
}