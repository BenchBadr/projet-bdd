import { ThemeProvider } from './util/ThemeContext';


const ToExport = ({children}) => {
  return (
    <ThemeProvider>
      {children}
    </ThemeProvider>
  )

}

export default ToExport;
