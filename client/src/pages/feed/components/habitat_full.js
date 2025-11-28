import Md from "../../../util/markdown";
import { useParams } from "react-router";
import { useEffect, useState } from "react";

const HabitatFull = () => {
    const { id } = useParams();
    const [data, setData] = useState(null);


    useEffect(() => {
        fetch('/habitat_full', {
            method:'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body:JSON.stringify({id : id})
        })
            .then(response => response.json())
            .then(data => setData(data))
            .catch(error => console.error(error));
    }, [])

    console.log(data)
    return (
        <>
        <h1>HELLO</h1>
        </>
    )
}

export default HabitatFull;

