import { useState, useEffect } from "react";
import Sortie from "../components/sortie";

const Outings = () => {
    const [data, setData] = useState(null);

    useEffect(() => {
        fetch('/sorties')
            .then(response => response.json())
            .then(data => setData(data))
            .catch(error => console.error(error));
    }, [])

    return (
        <div className="sortie-container">
        {data && data.map((sortie) => (
            <Sortie key={sortie.id} data={sortie}/>
        ))}
        </div>
    )
}

export default Outings;