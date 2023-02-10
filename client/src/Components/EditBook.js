import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';

class EditBook extends Component {
    constructor(props){
        super(props);
        this.state = {
            name: '',
            author: '',
            year: '',
            rating: ''
        };
        this.onChange = this.onChange.bind(this);
        this.onClick = this.onClick.bind(this);
    }

    onChange = function(e) {
        this.setState({ [e.target.name]: e.target.value})
    }

    onClick = function() {
        /*e not needed. it will not allow information to be passed because
        link will activate first?*/
        
        //e.preventDefault();
        
        const editBook = {
            //don't forget the _ in _id
            id: this.props.match.params._id,
            name: this.state.name,
            author: this.state.author,
            rating: this.state.rating,
            year: this.state.year
        }
        this.props.updateBook(editBook);
    }

    render() {

        console.log(this.props.match.params._id)
        return (
            <form>
                <div className="form-group">
                    <label>Name </label>
                    <input type="text" className="form-control" 
                    name="name"
                    value={this.state.name}
                    onChange={this.onChange}/>
                </div>
                <div className="form-group">
                    <label>Author </label>
                    <input type="text" className="form-control" 
                    name="author"
                    value={this.state.author}
                    onChange={this.onChange}/>
                </div>
                <div className="form-group">
                    <label>Rating</label>
                    <input type="text" className="form-control" 
                    name="rating"
                    value={this.state.rating}
                    onChange={this.onChange}/>
                </div>
                <div className="form-group">
                    <label> Publication Year </label>
                    <input type="text" className="form-control" 
                    name="year"
                    value={this.state.year}
                    onChange={this.onChange}/>
                </div>
                <div className="form-group">
                    <Link to="/" onClick={this.onClick}>
                        <input type="submit" className="form-control bg-primary"
                        style={{color:"white"}}
                        value="submit"/>
                    </Link>
                </div>
            </form>
        )
    }
}

export default EditBook