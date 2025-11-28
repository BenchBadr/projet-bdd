import { useContext } from "react";
import ThemeContext from "../../../util/ThemeContext";

const Specie = ({data}) => {

    const { lang } = useContext(ThemeContext);

    console.log(data)

    return (
        <div className="sortie">
            <div className="title">{data.nom}</div>
            <div className="theme">{data.nom_sci}</div>

            <img src={data.img} className="img-specie"/>

            <div className="bottom-info">
                <div className="icons">
                    <span>
                        <a>grass</a>
                        <span style={{marginRight:'.5em'}}>{data.habitatcount}</span>
                        {{
                            'fr':"Habitat",
                            "en":"Habitat"
                        }[lang]} 
                        {data.habitatcount > 1 && 's'}
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

export default Specie;