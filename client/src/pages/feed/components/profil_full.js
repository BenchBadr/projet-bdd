import { useState, useEffect, useContext } from "react";import ThemeContext from "../../../util/ThemeContext";
import { useParams } from "react-router";

const ProfilFull = () => {
    const [data, setData] = useState([]);
    const {id} = useParams();

    useEffect(() => {
        fetch('/profil_full',{
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
        <p>YOO profil : {data.profil && data.profil[0]} </p>
    )
}

export default ProfilFull;