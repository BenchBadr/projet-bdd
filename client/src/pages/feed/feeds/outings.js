import { useState, useEffect, createContext, useContext } from "react";
import Sortie from "../components/sortie";
import ThemeContext from "../../../util/ThemeContext";


export const SearchContext = createContext();

const Outings = () => {
    const [data, setData] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [themes, setThemes] = useState({});
    const [themeFilt, setThemeFilt] = useState(null);
    const [avOnly, setAvOnly] = useState(false); // Pour restreindre aux sorties disponibles seulement
    const { lang } = useContext(ThemeContext);

    useEffect(() => {
        fetch('/sorties')
            .then(response => response.json())
            .then(data => setData(data))
            .catch(error => console.error(error));
    }, [])

    const addTheme = (theme) => {
        setThemes((prevThemes) => ({
            ...prevThemes,
            [theme]: (prevThemes[theme] || 0) + 1,
        }));
    };

    console.log(themeFilt);





    return (
        <SearchContext.Provider value={{searchTerm, addTheme, themeFilt, avOnly}}>
            <div className="results-container">
                <div className="search-options">
                    <div className="search-bar">
                        <input type="text" placeholder={{
                            'fr': "Tapez votre recherche...",
                            'en':'Type your search term...'
                        }[lang]}
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        />
                        <span>search</span>
                    </div>
                    <div className="search-filters">
                        
                        <span>

                            <a>{{
                                'fr':'Thèmes',
                                'en':'Themes'
                            }[lang]} : </a>

                            {themes && (
                                <select 
                                value={themeFilt}
                                onChange={e => setThemeFilt(e.target.value)}
                                >
                                    <option value={''}>---</option>
                                    {Object.keys(themes).map((theme) => <option value={theme}>{theme}</option>)}
                                </select>
                            )}

                        </span>

                        <span>
                            <a>{{
                                'fr':'Disponible seulement',
                                'en':'Available only'
                            }[lang]}</a>

                            <label className="switch">
                                <input type="checkbox" checked={avOnly} onChange={e => setAvOnly(e.value)}/>
                                <span className="slider round"></span>
                            </label>

                        </span>

                    </div>
                </div>
                <div className="sortie-container">
                    {data && data.map((sortie) => (
                        <Sortie key={sortie.id} data={sortie}/>
                    ))}
                </div>
            </div>
        </SearchContext.Provider>
    )
}

export default Outings;