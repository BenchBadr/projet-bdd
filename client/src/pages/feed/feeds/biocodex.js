import { useState, useEffect, useContext } from "react";
import Habitat from "../components/habitat";
import ThemeContext from "../../../util/ThemeContext";


const PagesFlow = ({currentPage, maxPages, setPage}) => {
    return (
        <div className="pages-display">
            {currentPage != 0 ? <div className="arrow"
            onClick={() => setPage(currentPage - 1)}
            >chevron_left</div> : <div style={{background:'transparent'}}/>}
            {Array.from({ length: maxPages }, (_, i) => (
                Math.abs(i - currentPage) < 3 || i === 0 || i === maxPages - 1 ? (<div
                    key={i}
                    className={currentPage === i ? "active" : ""}
                    onClick={() => typeof setPage === "function" && setPage(i)}
                >
                    {i + 1}
                </div>) : (
                    (
                        (
                            Math.abs(i - currentPage) < (5 + Math.max(5 - currentPage, 0) + Math.max(5 - maxPages + currentPage, 0)) 
                        ) 
                    ) && (
                        <div className="empty"></div>
                    )
                )
            ))}
            {currentPage != maxPages-1 ? <div className="arrow"
            onClick={() => setPage(currentPage + 1)}
            >chevron_right</div> : <div style={{background:'transparent'}}/>}
        </div>
    );
}

const Biocodex = () => {
    const [nichoirs, setNichoirs] = useState([]);
    const [biomes, setBiomes] = useState([]);
    const [option, setOption] = useState(1);
    const [searchTerm, setSearchTerm] = useState('');
    const [pagesCount, setPagesCount] = useState([0,0,0]);
    const [page, setPage] = useState(0);
    const { lang } = useContext(ThemeContext);

    useEffect(() => {
            fetch('/count_bioco', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ query:searchTerm })
                })
                .then(response => response.json())
                .then(data => setPagesCount(data.count))
                .catch(error => console.error(error));

            if (option === 1) {
                fetch('/nichoirs', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ offset: page * 9, query:searchTerm })
                })
                .then(response => response.json())
                .then(data => setNichoirs(data))
                .catch(error => console.error(error));
            }

            if (option === 2) {
                fetch('/biomes', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ offset: page * 9, query:searchTerm })
                    })
                    .then(response => response.json())
                    .then(data => setBiomes(data))
                    .catch(error => console.error(error));
            }
        }, [page, option,searchTerm])

    useEffect(() => {setPage(0);setSearchTerm('')}, [option])

    console.log(pagesCount)



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

                {(option === 1 || option === 2) && (
                    <div className="search-bar biocodex">
                        <input type="text" placeholder={{
                            'fr': "Tapez votre recherche...",
                            'en':'Type your search term...'
                        }[lang]}
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        />
                        <span>search</span>
                    </div>
                )}
            </div>



            {option === 1 && <div className="sortie-container habitat">
                {nichoirs.map((nichoir) => (
                    <Habitat data={nichoir}/>
                ))}
                {pagesCount[option]>9 &&  <PagesFlow setPage={setPage} maxPages={Math.ceil(pagesCount[option]/9)} currentPage={page}/>}
            </div>}

            {option === 2 && <div className="sortie-container habitat">
                {biomes.map((biome) => (
                    <Habitat data={biome}/>
                ))}
                {pagesCount[option]>9 && <PagesFlow setPage={setPage} maxPages={Math.ceil(pagesCount[option]/9)} currentPage={page}/>}
            </div>}

        </div>
    )
}

export default Biocodex;