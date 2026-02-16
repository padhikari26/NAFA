// Install: npm install @tinymce/tinymce-react
import React from 'react';
import { Editor } from '@tinymce/tinymce-react';

interface TinyMCEWrapperProps {
    data: string;
    onChange: (data: string) => void;
}

export default function TinyMCEWrapper({ data, onChange }: TinyMCEWrapperProps) {
    const editorRef = React.useRef<any>(null);
    const [loading, setLoading] = React.useState(true);

    return (
        <div style={{ position: "relative" }}>
            {loading && (
                <div
                    style={{
                        position: "absolute",
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        backgroundColor: "rgba(255,255,255,0.8)",
                        zIndex: 10
                    }}
                >
                    <span>Loading editor...</span>
                </div>
            )}

            <Editor
                apiKey="zwdauj5p2x0rg06qvter0ugu6tr2o4f4batbp38ru49m4tb7"
                onInit={(_evt, editor) => {
                    editorRef.current = editor;
                    setLoading(false);
                }}
                value={data}
                onEditorChange={(content) => onChange(content)}
                init={{
                    menubar: false,
                    plugins: [
                        "advlist", "autolink", "lists", "link", "image", "charmap", "preview",
                        "anchor", "searchreplace", "visualblocks", "code", "fullscreen",
                        "insertdatetime", "media", "table", "code", "help", "wordcount"
                    ],
                    toolbar:
                        "undo redo | blocks | " +
                        "bold italic forecolor | alignleft aligncenter " +
                        "alignright alignjustify | bullist numlist outdent indent | " +
                        "removeformat | help",
                    content_style:
                        "body { font-family:Helvetica,Arial,sans-serif; font-size:14px }"
                }}
            />
        </div>
    );
}
