import { useState, useEffect, useContext } from "react";import ThemeContext from "../../../util/ThemeContext";
import { useParams } from "react-router";

const Specie = ({data}) => {

    const { lang } = useContext(ThemeContext);


    return (
        <div className="sortie">
            <div className="title">{data.nom}</div>
            <div className="theme">{data.nom_sci}</div>

            <img src={data.img+'?width=512'} className="img-specie"/>

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

                    <span>
                        <a>class</a>
                        <span style={{marginRight:'.5em'}}>{data.groupe}</span>
                    </span>
                </div>
            </div>

            <div className="see-more" onClick={() => window.location.href=(`/animal/${data.nom_sci}`)}>
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