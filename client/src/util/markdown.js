import ReactMarkdown from 'react-markdown';
import { useRef, useState, useEffect } from 'react';

const Md = ({ children }) => (
    <ReactMarkdown
    >
        {children}
    </ReactMarkdown>
);

export const DeMark = ({ children }) => {
    const markdownRef = useRef(null); 
    const [plainText, setPlainText] = useState('');

    useEffect(() => {
        if (markdownRef.current) {
            setPlainText(markdownRef.current.textContent || '');
        }
    }, [children]); 

    return (
        <>
            <div ref={markdownRef} style={{ display: 'none' }}>
                <ReactMarkdown>{children}</ReactMarkdown>
            </div>

            <span>{plainText}</span>
        </>
    );
};

export default Md;