import { useContext, useState } from "react";
import ThemeContext from "../../util/ThemeContext";
import General from "./feeds/general";
import Outings from "./feeds/outings";
import './feed.css'

const Feed = () => {
    const { lang } = useContext(ThemeContext);
    return (
        <div className="main-container">
            <div className="sidepanel"></div>
            <div className="mainpanel">
                <MainPanel/>
            </div>
            <div className="rightpanel"></div>
        </div>
    )
}

export default Feed;

const MainPanel = () => {
    const { lang } = useContext(ThemeContext);
    const [option, setOption] = useState(0);

    return (
        <>
            <div className="maintopbar">
                <div className={`selection ${option === 0 && 'active'}`}
                    onClick={() => setOption(0)}
                >
                    <span>home</span>
                    {{'fr':"Général", 'en':"General"}[lang]}
                </div>
                <div className={`selection ${option === 1 && 'active'}`}
                    onClick={() => setOption(1)}
                >
                    <span>grass</span>
                    {{'fr':"Sorties", 'en':"Outings"}[lang]}
                </div>
                <div className={`selection ${option === 2 && 'active'}`}
                    onClick={() => setOption(2)}
                >
                    <span>source</span>
                    {{'fr':"Biocodex", 'en':"Biocodex"}[lang]}
                </div>
            </div>
            <div className="mainbotbar">
                {option === 1 && <Outings/>}
            </div>
        </>
    )
}