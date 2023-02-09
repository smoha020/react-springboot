import React, { Component} from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.css'; 
import axios from 'axios';

import Navbar from './Components/Navbar';
import BookList from './Components/BookList';
import CreateBook from './Components/CreateBook';
import EditBook from './Components/EditBook';
import CreateAuthor from './Components/CreateAuthor';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      books: [],
      greeting: '',
      authors: []
    }    
    this.addBook = this.addBook.bind(this);
    this.updateBook = this.updateBook.bind(this);
    this.deleteBook = this.deleteBook.bind(this);
    this.addAuthor = this.addAuthor.bind(this);
  }
  
  componentDidMount() {
    axios.get('localhost:8080/')
      .then(res => this.setState({greeting: [...res.data]}))
      .catch(err => console.log(err));

    axios.get('localhost:8080/getbooks')
      .then(res => this.setState({books: [...res.data]}))
      .catch(err => console.log(err));
    
    axios.get('/author')
      .then(res => this.setState({authors: [...res.data]}))
      .catch(err => console.log(err));
  }

  //do not use JSON.stringify.
  addBook = function(book) {
    
    axios.post('localhost:8080/addbook', book)
    .then(res => this.setState({books: [...this.state.books, res.data]}))
      .catch(err => console.log(err));
  }

  updateBook = function(edBook) {
    console.log(edBook);
    axios.put(`localhost:8080/updatebook/${edBook._id}`, edBook)
      .then(() => this.setState({books: [...this.state.books.map(book => {
        if(edBook._id === book._id) {
          book.name = edBook.name;
          book.author = edBook.author;
          book.rating = edBook.rating;
          book.year = edBook.year;
          console.log(book);
        }
        return book;
      })]}))
      .catch(err => console.log(err));
  }

  deleteBook = function(delBook) {
    console.log(delBook)
    axios.delete(`localhost:8080/deletebook/${delBook._id}`)
      .then(res => this.setState({books: [...this.state.books.filter(book => (
        book._id != delBook._id
        ))]
      }))
      .catch(err => console.log(err));
  }

  addAuthor = function(newAuthor) {

    const new_id = this.state.books.map(book => {
      if(book.author == newAuthor) {
        console.log(book._id)
        return book._id
      }
    })
    
    /*I use [0] because the _id is inside of 
    an array and the _id is always the only element inside*/
    const Author = {
      _id: new_id[0],
      author: newAuthor
    }

    axios.post('/author', Author)
      .then(res => this.setState({authors: [...this.state.authors, Author]}))
      .catch(err => console.log(err));
  }

/*when rendering components we use {...props} to be able to access 
all props properties such as  props.match...etc*/
  render() {
    console.log(this.state.authors)
    return (
      <Router>
        <div className="container">
          <Route exact path="/" render={props => ( <Navbar
            greeting={this.state.greeting} />) }/>
          <Route exact path="/" render={props => ( <BookList
            addBook={this.addBook}
            deleteBook={this.deleteBook}
            books={this.state.books} />) }/>
          <Route path="/create" render={props => ( <CreateBook
            addBook={this.addBook}
            authors={this.state.authors} />) }/>
          <Route path="/edit/:_id"  render={props => ( <EditBook
              {...props}
              books={this.state.books} 
              authors={this.state.authors}
              updateBook={this.updateBook}/>) }/> 
          <Route path="/author" render={props => ( <CreateAuthor
            addAuthor={this.addAuthor} />) }/>
        </div>
      </Router>
    )
  };
}

export default App;