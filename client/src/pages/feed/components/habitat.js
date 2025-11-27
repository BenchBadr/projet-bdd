import { useContext } from "react";
import MapPreview from "./map";
import ThemeContext from "../../../util/ThemeContext";

const Habitat = ({data}) => {
    const {lang} = useContext(ThemeContext);

    return (
        <div className="sortie">
            <div className="title" style={{marginBottom:'1em'}}>{data.nomhabitat}</div>

            <MapPreview coords={data.coords}/>

            <div className="bottom-info">
                <div className="icons">
                    <span>
                        <a>people</a>
                        {data.nb_pers} {{'fr':'visiteurs', 'en':'visitors'}[lang]}
                    </span>

                    <span>
                        <a>pets</a>
                        {data.nb_pers} {{'fr':'espèces repérées', 'en':'species seen'}[lang]}
                    </span>

                    <span>
                        <a>perm_media</a>
                        {data.nb_images} {{'fr':'images', 'en':'pictures'}[lang]}
                    </span>

                </div>
            </div>

            <div className="see-more">
                <a>visibility</a>
                {{
                    "fr":"En savoir plus",
                    "en":"Learn more"
                }[lang]}
            </div>
        </div>
    )
}

export default Habitat;