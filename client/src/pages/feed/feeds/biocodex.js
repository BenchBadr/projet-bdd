import { useState, useEffect, useContext } from "react";
import Habitat from "../components/habitat";
import ThemeContext from "../../../util/ThemeContext";

const Biocodex = () => {
    const [nichoirs, setNichoirs] = useState([]);
    const [biomes, setBiomes] = useState([]);
    const { lang } = useContext(ThemeContext);

    useEffect(() => {
            fetch('/nichoirs')
                .then(response => response.json())
                .then(data => setNichoirs(data))
                .catch(error => console.error(error));

            fetch('/biomes')
                .then(response => response.json())
                .then(data => setBiomes(data))
                .catch(error => console.error(error));
        }, [])


    return (
        <>
            <div className="fancy-title">
                {{
                    'fr':'Nichoirs',
                    'en': 'Nest boxes'
                }[lang]}
            </div>
            <div className="sortie-container habitat">
                {nichoirs.map((nichoir) => (
                    <Habitat data={nichoir}/>
                ))}
            </div>
            <div className="fancy-title">
                {{
                    'fr':'Autres biômes',
                    'en': 'Other biomes'
                }[lang]}
            </div>
            <div className="sortie-container habitat">
                {biomes.map((biome) => (
                    <Habitat data={biome}/>
                ))}
            </div>
            <div className="fancy-title">
                {{
                    'fr':'Espèces',
                    'en': 'Species'
                }[lang]}
            </div>
        </>
    )
}

export default Biocodex;