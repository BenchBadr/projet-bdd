import { useContext } from 'react';
import './homepage.css';
import ThemeContext from '../../util/ThemeContext';

const Homepage = () => {
    const { lang } = useContext(ThemeContext);

  return (
    <div className='homepage'>
        <div className='panel'>
            <img 
                src={`/brand/oak-goyen.jpg`} 
                alt="Goyen" 
                className='landscape'
            ></img>

            <div className='welcome'>
                <img src={`/brand/logo.png`} className='logo-home'/>
                <h1 className='cop'>
                    {{
                        "fr" : "Contents de vous revoir!",
                        "en" : "Welcome back!"
                    }[lang]}
                </h1>
                <div style={{textAlign:'center'}}>
                    {{
                        "fr":"Choisissez un moyen d'authentification.",
                        "en":"Choose an authentication method."
                    }[lang]}
                </div>
                <EiffelAuth/>
                <GoogleAuth/>
                <QuickSettings/>
            </div>
        </div>

    </div>
  )
}

export default Homepage;


const EiffelAuth = () => {

    const { lang, setAlert } = useContext(ThemeContext);

    const alert = {
        title: {
            "fr":"Fonctionnalité indisponible.",
            "en" : "Feature unavailable"
        },
        desc: {
            "fr" : "Nous ne disposons pas d'accès aux serveurs de l'université... pour le moment.",
            "en" : "We do not have access to the university servers... for now."
        }
    }

    return (
        <div className='auth eiffel' onClick={() => setAlert(alert)}>
            <img src={`/brand/eiffel-white.png`}/>
            EiffelAuth ®
        </div>
    )
}


const GoogleAuth = () => {
    const { lang, setAlert } = useContext(ThemeContext);

    const alert = {
        title: {
            "fr":"Fonctionnalité indisponible.",
            "en" : "Feature unavailable"
        },
        desc: {
            "fr" : "La connexion via Google n'est pas prise en charge pour le moment.",
            "en" : "Google sign-in is not supported at the moment."
        }
    }

    console.log(alert);

    return (
        <div className='auth google' onClick={() => setAlert(alert)}>
            <img src={`https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png`}/>
            {
                {
                    "fr" : "Se connecter avec Google",
                    "en" : "Sign in with Google"
                }[lang]
            }
        </div>
    )
}


const QuickSettings = () => {
    const { theme, toggleTheme, setAlert } = useContext(ThemeContext);


    return (
        <div className='quicksets'>
            <div className='left'>
                <LanguageSelect/>
            </div>
            <div className='right'>
                <div className='theme-toggle' onClick={() => toggleTheme()}>
                    {theme === 'dark' ? 'bedtime' : 'sunny'} 
                </div>
            </div>
        </div>
    )
}

const LanguageSelect = () => {
    const { lang, changeLanguage } = useContext(ThemeContext);


    return (
        <select
            value={lang}
            onChange={e => changeLanguage(e.target.value)}
            className="lang-select"
        >
            <option value="fr">Français</option>
            <option value="en">English</option>
        </select>
    );
}