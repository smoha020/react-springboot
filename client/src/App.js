import React, { Component} from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.css'; 
import axios from 'axios';

import Navbar from './Components/Navbar';
import BookList from './Components/BookList';
import CreateBook from './Components/CreateBook';
import EditBook from './Components/EditBook';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      books: [],
      greeting: ''
    }    
    this.addBook = this.addBook.bind(this);
    this.updateBook = this.updateBook.bind(this);
    this.deleteBook = this.deleteBook.bind(this);
  }
  
  componentDidMount() {
    axios.get('/api/')
      .then(res => {
        console.log(res)
        this.setState({greeting: [...res.data]})
      })
      .catch(err => console.log(err));

    axios.get('/api/getbooks')
      .then(res => {
        console.log(res.data)
        this.setState({books: [...res.data]})})
      .catch(err => console.log(err));
    
  }

  //do not use JSON.stringify.
  addBook = function(book) {
    
    axios.post('/api/addbook', book)
    .then(res => this.setState({books: [...this.state.books, res.data]}))
      .catch(err => console.log(err));
  }

  updateBook = function(edBook) {
    console.log(edBook);
    axios.put(`/api/updatebook/`, edBook)
      .then(() => this.setState({books: [...this.state.books.map(book => {
        if(edBook.id === book.id) {
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
    axios.delete(`/api/deletebook/${delBook.id}`)
      .then(res => this.setState({books: [...this.state.books.filter(book => (
        book.id != delBook.id
        ))]
      }))
      .catch(err => console.log(err));
  }

  

/*when rendering components we use {...props} to be able to access 
all props properties such as  props.match...etc*/
  render() {

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
            addBook={this.addBook}/>) }/>
          <Route path="/edit/:_id"  render={props => ( <EditBook
              {...props}
              books={this.state.books} 
              updateBook={this.updateBook}/>) }/> 
        </div>
      </Router>
    )
  };
}

export default App;