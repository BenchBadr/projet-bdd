import Md from "../../../util/markdown";


const Sortie = ({key, data}) => {
    
    return (
        <div className="sortie">
            <div className="title">{data.nom}</div>
            <div className="theme">{data.theme}</div>
            <Md>{data.descriptif}</Md>
        </div>
    )
}

export default Sortie;