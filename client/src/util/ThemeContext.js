import { createContext } from "react";
import React, { useState, useContext } from "react";

const ThemeContext = createContext();

export default ThemeContext;

export const ThemeProvider = ({ children }) => {
    const [theme, setTheme] = useState("light");
    const [lang, setLang] = useState("fr");
    const [alert, setAlert] = useState(null);

    const toggleTheme = () => {
        setTheme((prev) => (prev === "light" ? "dark" : "light"));
    };

    return (
        <ThemeContext.Provider value={{ theme, toggleTheme, lang, setLang, alert, setAlert }}>
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
    }


    return (
        <>
        {alert && <div className="tenebres">
            <div className="modal">
                <b>{alert.title[lang]}</b>
                <p>{alert.desc[lang]}</p>
                <div className="btn"
                    onClick={() => emptyAlert()}
                >
                    {{
                        "fr" : "Compris!",
                        "en" : "Understood!"
                    }[lang]}
                </div>
            </div>
        </div>}
        </>
    )
}