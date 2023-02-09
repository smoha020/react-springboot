import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { v4 as uuidv4 } from 'uuid';
import Axios from 'axios';

class CreateExercise extends Component {
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

    componentDidMount() {
        console.log(this.props.authors);
    }

    onChange = function(e) {
        this.setState({ [e.target.name]: e.target.value})
    }

    onClick = function() {

        const newBook = {
            name: this.state.name,
            author: this.state.author,
            rating: this.state.rating,
            year: this.state.year
        }
        this.props.addBook(newBook);
    }

    render() {
        console.log(this.props.authors)
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
                    <label>Author</label>
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

export default CreateExercise 