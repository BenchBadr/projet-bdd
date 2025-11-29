import Md from "../../../util/markdown";
import { useParams } from "react-router";
import { useContext, useEffect, useState } from "react";
import MapPreview from "./map";
import ThemeContext from "../../../util/ThemeContext";
import RightPanel from "./rightpan";
import Specie from "./animal";
import { PagesFlow } from "../feeds/biocodex";
import Profile from "./profile";

const HabitatFull = () => {
    const { id } = useParams();
    const [data, setData] = useState(null);
    const {lang} = useContext(ThemeContext);


    useEffect(() => {
        fetch('/habitat_full', {
            method:'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body:JSON.stringify({id : id})
        })
            .then(response => response.json())
            .then(data => setData(data))
            .catch(error => console.error(error));
    }, [])

    return (
        <div className="main-container">
            <div className="sidepanel"></div>
            <div className="mainpanel habitat">
                {data && (
                    <div className="habitat-display">
                        <MapPreview coords={data[0].coords} zoom={13}/>
                        <h1 className="cop">{data[0].nomhabitat}</h1>

                        <div className="icons" style={{paddingBottom:'10em'}}>
                            <span>
                                <a>people</a>
                                {data[0].nb_pers} {{'fr':'visiteurs', 'en':'visitors'}[lang]}
                            </span>

                            <span>
                                <a>pets</a>
                                {data[0].nb_pers} {{'fr':'espèces repérées', 'en':'species seen'}[lang]}
                            </span>

                            <span>
                                <a>perm_media</a>
                                {data[0].nb_images} {{'fr':'images', 'en':'pictures'}[lang]}
                            </span>
                        </div>

                        <h1 className="cop">{{'fr':'Espèces repérées', 'en':'Species seen'}[lang]}</h1>

                        <SpeciesDisplay habId={id}/>

                        {data[1] && (<>
                            <h1 className="cop"> {{'fr':'Visiteurs', 'en':'Visitors'}[lang]} ({data[0].nb_pers})</h1>
                            {data[1].map((profile) => <Profile data={profile}/>)}
                        </>)}
                    </div>
                )}
            </div>
            <div className="rightpanel">
                <RightPanel/>
            </div>
        </div>
    )
}



export default HabitatFull;

const SpeciesDisplay = ({habId}) => {
    const [animals, setAnimals] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [groups, setGroups] = useState(['Amphibien', 'Oiseaux']);
    const [groupFilt, setGroupFilt] = useState('');
    const [page, setPage] = useState(0);
    const [pagesCount, setPagesCount] = useState([]);
    const {lang} = useContext(ThemeContext);


    useEffect(() => {
        // Recuperer les differents grp pour filtrer
        fetch('/get_grps')
        .then(response => response.json())
        .then(data => setGroups(data.grps))
    }, [])


    useEffect(() => {
            setAnimals([]);
            setPage(0);

            fetch('/count_bioco', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ query:searchTerm, grp_anim:groupFilt, hab:habId })
                })
                .then(response => response.json())
                .then(data => setPagesCount(data.count))
                .catch(error => console.error(error));

            fetch('/species', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ offset: page * 9, query:searchTerm, grp:groupFilt, habitat:habId })
            })
            .then(response => response.json())
            .then(data => setAnimals(data))
            .catch(error => console.error(error));

        }, [page,searchTerm, groupFilt])

    return (
        <>
        
         {animals && <div className="search-filters animal">
                        
            <span>

                <a>{{
                    'fr':'Groupe taxomonique',
                    'en':'Taxomonic group'
                }[lang]} : </a>

                {groups && (
                    <select 
                    value={groupFilt}
                    onChange={e => setGroupFilt(e.target.value)}
                    >
                        <option value={''}>---</option>
                        {groups.map((group) => <option value={group}>{group}</option>)}
                    </select>
                )}

            </span>

            {<div className="sortie-container habitat full">
                {animals.map((animal) => (
                    <Specie data={animal}/>
                ))}
                {pagesCount[0]>9 && <PagesFlow setPage={setPage} maxPages={Math.ceil(pagesCount[0]/9)} currentPage={page}/>}
            </div>}

        </div>}
        
        </>

    )
}

