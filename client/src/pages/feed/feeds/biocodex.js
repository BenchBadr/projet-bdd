import { useState, useEffect, useContext } from "react";
import Habitat from "../components/habitat";
import ThemeContext from "../../../util/ThemeContext";

const Biocodex = () => {
    const [nichoirs, setNichoirs] = useState([]);
    const [biomes, setBiomes] = useState([]);
    const [option, setOption] = useState(1);
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
        <div className="results-container">
            <div className="search-options">
                <div className="option-selector">
                    <div className={option === 1 && 'selected'} onClick={() => setOption(1)}>
                        <span>holiday_village</span>
                        {{
                            'fr':'Nichoirs',
                            'en': 'Nest boxes'
                        }[lang]}
                    </div>
                    <div className={option === 0 && 'selected'} onClick={() => setOption(0)}>
                        <span>cruelty_free</span>
                        {{
                            'fr':'Espèces',
                            'en': 'Species'
                        }[lang]}
                    </div>
                    <div className={option === 2 && 'selected'} onClick={() => setOption(2)}>
                        <span>forest</span>
                        {{
                            'fr':'Autres biômes',
                            'en': 'Other biomes'
                        }[lang]}
                    </div>
                </div>

                <h1>HELLO</h1>
            </div>



            {option === 1 && <div className="sortie-container habitat">
                {nichoirs.map((nichoir) => (
                    <Habitat data={nichoir}/>
                ))}
            </div>}
            {option === 2 && <div className="sortie-container habitat">
                {biomes.map((biome) => (
                    <Habitat data={biome}/>
                ))}
            </div>}

        </div>
    )
}

export default Biocodex;