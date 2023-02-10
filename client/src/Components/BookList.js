import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';

class BookList extends Component {

  
  render() {
    const { books, deleteBook } = this.props;
    return(
      <React.Fragment>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Author</th>
              <th scope="col">Rating</th>
              <th scope="col">Year</th>
              <th scope="col">Edit/Delete</th>
            </tr>
          </thead>
          <tbody>
          {books.map(book => (
            //the key should be for <React.Fragment> not for <tr>
            <React.Fragment key={book.id}>
              <tr>
                <td> {book.name} </td>
                <td> {book.author} </td>
                <td> {book.rating} </td>
                <td> {book.year} </td> 
                <td> 
                  <Link to={`/edit/${book.id}`} style={{color:'white', textAlign:'center'}} 
                  className="form-control bg-primary ">Edit
                  </Link> 
                  <button style={{color:'white'}} onClick={deleteBook.bind(this, book)} 
                  className="form-control bg-danger ">Delete
                  </button> 
                </td>
              </tr>
            </React.Fragment>)
          )}
          </tbody>
        </table>
      </React.Fragment> 
    )  
  }
}

export default BookList 