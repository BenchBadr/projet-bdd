import { useContext, useEffect } from "react";
import DeMark from "../../../util/markdown";
import ThemeContext from "../../../util/ThemeContext";
import { SearchContext } from "../feeds/outings";

const formatDateIntl = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit' });
};


const Sortie = ({key, data}) => {
    const {lang} = useContext(ThemeContext);
    const {searchTerm, addTheme, themeFilt, avOnly} = useContext(SearchContext);

    useEffect(() => {
        if (data.theme) {
            addTheme(data.theme);
        }

    }, [data])

    return (
        <>
        {data && (!avOnly || ((data.inscrits < data.effectif_max)) && (
            data.date_rdv && new Date(data.date_rdv) < new Date()
        ))
        && (!themeFilt || data.theme == themeFilt) 
        && (data.nom && (!searchTerm || (searchTerm && data.nom.toLowerCase().startsWith(searchTerm.toLowerCase())))) && (
        <div className="sortie">
            <div className="title">{data.nom}</div>
            <div className="theme">{data.theme}</div>
            <div className="description">
                <DeMark>{data.descriptif}</DeMark>
            </div>

            <div className="bottom-info">

                <div className="icons">
                    <span>
                        <a>directions_railway</a>
                        {data.distance_km} km
                    </span>
                    <span style={{color:`var(--${data.inscrits < data.effectif_max ? 'green' : 'red'})`}}>
                        <a>people</a>
                        {data.inscrits} / {data.effectif_max}
                    </span>
                    <span>
                        <a>calendar_today</a>
                        {formatDateIntl(data.date_rdv)}
                    </span>
                </div>

                <div className="location">
                    <a>location_on</a>
                    <span>{data.lieu}</span>
                </div>

                <div className="see-more" onClick={() => window.location.href = `/sorties/${data.idsortie}`}>
                    <a>visibility</a>
                    {{
                        "fr":"Voir plus",
                        "en":"See more"
                    }[lang]}
                </div>
            </div>
        </div>
        )}
        </>
    )
}

export default Sortie;