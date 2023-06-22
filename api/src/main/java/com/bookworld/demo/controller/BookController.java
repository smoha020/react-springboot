package com.bookworld.demo.controller;

import com.bookworld.demo.model.Book;
import com.bookworld.demo.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/")
    public String hello(){
        return "welcome my FRIEND!!!";
    }

    @GetMapping("/getbooks")
    public List<Book> ShowBooks() {

        return bookService.getBooks();
    }

    @GetMapping("/getbook/{id}")
    public Book showBook(@PathVariable int id) {
        return bookService.getBook(id);
    }

    @PostMapping("/addbook")
    public void AddBook(@RequestBody Book book) {
        bookService.saveBook(book);
    }

    @PutMapping("/updatebook")
    public String changeBook(@RequestBody Book book) {
        /*
        it's not enough to just call the update method below.
        You must return something. Even if it's just a String
        saying "hello"
        */
        return bookService.update(book);
    }

    /*
    Requests made from browser are only GET requests.
    Therefore, Postman is needed
    */
    @DeleteMapping("/deletebook/{id}")
    public String dropBook(@PathVariable int id) {
        return bookService.delete(id);
    }
}
