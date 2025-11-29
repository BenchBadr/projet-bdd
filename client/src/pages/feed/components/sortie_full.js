import Md from "../../../util/markdown";
import { useParams } from "react-router";
import { useEffect } from "react";

const SortieFull = () => {
    const { id } = useParams();
    const [data, setData] = setData(null);


    useEffect(() => {
        fetch('/sortie_full', {
            methods:'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body:JSON.stringify({id : id})
        })
            .then(response => response.json())
            .then(data => setData(data))
    }, [])

    console.log(data)
    return (
        <></>
    )
}

export default SortieFull;

