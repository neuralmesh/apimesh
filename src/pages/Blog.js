import React, { useEffect, useState } from 'react';
import { marked } from 'marked';

const Blog = () => {
    const [files, setFiles] = useState([]);
    const [currentContent, setCurrentContent] = useState('');

    useEffect(() => {
        fetch('https://api.github.com/repos/neuralmesh/apimesh/contents/blog')
            .then(response => response.json())
            .then(files => setFiles(files));
    }, []);

    const fetchAndRenderMarkdown = (url) => {
        fetch(url)
            .then(response => response.text())
            .then(markdown => {
                const html = marked.parse(markdown);
                setCurrentContent(html);
            });
    };

    return (
        <div style={styles.container}>
            <div style={styles.navDrawer}>
                {files.map(file => (
                    <li key={file.name} style={styles.listItem} onClick={() => fetchAndRenderMarkdown(file.download_url)}>
                        {file.name}
                    </li>
                ))}
            </div>
            <div style={styles.mainContent} dangerouslySetInnerHTML={{ __html: currentContent }} />
        </div>
    );
};

const styles = {
    container: {
        display: 'flex',
    },
    navDrawer: {
        width: '200px',
        borderRight: '1px solid #ddd',
        padding: '10px',
        overflowY: 'auto',
    },
    mainContent: {
        flexGrow: 1,
        padding: '10px',
    },
    listItem: {
        cursor: 'pointer',
        marginBottom: '5px',
    },
};

export default Blog;

