import React, { Component } from 'react';
import Axios from 'axios';

class CreateAuthor extends Component {

    constructor(props){
        super(props);
            this.state = {
                author: ''
            };
            this.onChange = this.onChange.bind(this);
    }
   
    onChange = function(e) {
        this.setState({ [e.target.name]: e.target.value});
    }

    onSubmit = (e) => {
        e.preventDefault();
        console.log(this.state.author);
        this.props.addAuthor(this.state.author)
        this.setState({author: ''});
    }

    render() {
        return (
            <form onSubmit={this.onSubmit}>
                <div className="form-group">
                    <label>Author</label>
                    <input type="text" className="form-control" 
                    id="exampleFormControlInput1" 
                    name="author"
                    value={this.state.author}
                    onChange={this.onChange}/>
                </div>
                <div className="form-group">
                    <input type="submit" className="form-control bg-primary"
                    style={{color:"white"}}
                    id="exampleFormControlInput1" value="submit"/>
                </div>
            </form>
        )
    }
}

export default CreateAuthor