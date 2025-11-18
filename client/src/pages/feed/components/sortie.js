const Sortie = ({key, data}) => {
    return (
        <div className="sortie">
            <div className="title">{data.nom}</div>
            <div className="theme">{data.theme}</div>
        </div>
    )
}

export default Sortie;