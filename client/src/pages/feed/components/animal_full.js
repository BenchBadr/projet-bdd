import { useState, useEffect, useContext } from "react";import ThemeContext from "../../../util/ThemeContext";
import { useParams } from "react-router";

const Animal_full = () => {
    const [data, setData] = useState([]);
    const {id} = useParams();

    useEffect(() => {
        fetch('/animal_full',{
            method: 'POST',
            headers: {
                        'Content-Type': 'application/json'
                    },
            body: JSON.stringify({ id:id })
        })
            .then(response => response.json())
            .then(data => setData(data))
    }, [])
    console.log(data);
    console.log(id);
    return (
        <p>YOO {data.animal && data.animal[0].map((image) => <img src={image} style={{maxWidth:'100px'}}/>)} </p>
    )
}

export default Animal_full;