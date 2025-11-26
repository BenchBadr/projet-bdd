import Md from "../../../util/markdown";

const SortieFull = () => {

    useEffect(() => {
        fetch('/sortie_full')
            .then(response => response.json())
            .then(data => setData(data))
    }, [])
    return (
        <></>
    )
}

export default SortieFull;