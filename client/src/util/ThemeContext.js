import { createContext } from "react";
import React, { useState, useContext } from "react";
import Cookies from 'js-cookie';

const ThemeContext = createContext();

export default ThemeContext;

export const ThemeProvider = ({ children }) => {
    const [theme, setTheme] = useState(Cookies.get('theme') || 'light');
    const [lang, setLang] = useState(Cookies.get('lang') || "fr");
    const [alert, setAlert] = useState(null);

    const toggleTheme = () => {
        setTheme((prevTheme) => {
        const newTheme = prevTheme === 'light' ? 'dark' : 'light';
        Cookies.set('theme', newTheme, { expires: 365 });
        return newTheme;
        });
    };

    const changeLanguage = (newLang) => {
        setLang(newLang);
        Cookies.set('lang', newLang, { expires: 365 });
    };

    return (
        <ThemeContext.Provider value={{ theme, toggleTheme, lang, changeLanguage, alert, setAlert }}>
            <Modal/>
            <div className={`app ${theme}`}>
                {children}
            </div>
        </ThemeContext.Provider>
    );
};


const Modal = () => {
    const { lang, setAlert, alert } = useContext(ThemeContext);

    const emptyAlert = () => {
        setAlert(null);
    };

    const handleBackdropClick = (e) => {
        if (e.target.classList.contains("tenebres")) {
            emptyAlert();
        }
    };

    return (
        <>
        {alert && (
            <div className="tenebres" onClick={handleBackdropClick}>
                <div className="modal">
                    <b>{alert.title[lang]}</b>
                    <p>{alert.desc[lang]}</p>
                    <div className="btn"
                        onClick={emptyAlert}
                    >
                        {{
                            "fr": "Compris!",
                            "en": "Understood!"
                        }[lang]}
                    </div>
                </div>
            </div>
        )}
        </>
    );
};