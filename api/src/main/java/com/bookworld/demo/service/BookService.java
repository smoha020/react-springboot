package com.bookworld.demo.service;

import com.bookworld.demo.model.Book;
import com.bookworld.demo.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookService {

    @Autowired
    BookRepository bookRepository;
    //get books
    public List<Book> getBooks() {

        return bookRepository.findAll();
    }

    public Book getBook(int id) {
        return bookRepository.findById(id).orElse(null);
    }

    public void saveBook(Book book) {
        //System.out.println(book);
        bookRepository.save(book);
    }


    public String update(Book book) {
        Book oldbook = bookRepository.findById(book.getId()).orElse(null);
        oldbook.setName(book.getName());
        oldbook.setAuthor(book.getAuthor());
        oldbook.setYear(book.getYear());
        oldbook.setRating(book.getRating());
        System.out.println(oldbook);
        bookRepository.save(oldbook);
        return "book has been updated!";
    }

    public String delete(int id) {
        bookRepository.deleteById(id);
        return "book" + id + " has been deleted!";
    }
}
