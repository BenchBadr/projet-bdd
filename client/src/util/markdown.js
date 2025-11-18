import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import remarkFootnotes from 'remark-footnotes';
import remarkMath from 'remark-math';
import rehypeMathjax from 'rehype-mathjax';

const Md = ({ children }) => (
    <ReactMarkdown
    >
        {children}
    </ReactMarkdown>
);

export default Md;