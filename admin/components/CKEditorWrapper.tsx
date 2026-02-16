'use client'

import { useEffect, useState } from 'react'

// Types
interface CKEditorWrapperProps {
    data: string
    onChange: (data: string) => void
}

export default function CKEditorWrapper({ data, onChange }: CKEditorWrapperProps) {
    const [editor, setEditor] = useState<{
        CKEditor: any
        ClassicEditor: any
    } | null>(null)

    useEffect(() => {
        const loadEditor = async () => {
            try {
                // Use ckeditor5-build-classic which already includes List plugins in latest versions
                const [{ CKEditor }, ClassicEditor] = await Promise.all([
                    import('@ckeditor/ckeditor5-react'),
                    import('@ckeditor/ckeditor5-build-classic')
                ])

                setEditor({
                    CKEditor,
                    ClassicEditor: ClassicEditor.default || ClassicEditor
                })
            } catch (error) {
                console.error('Failed to load CKEditor:', error)
            }
        }

        loadEditor()
    }, [])

    if (!editor) {
        return (
            <div className="min-h-[200px] bg-gray-50 rounded border flex items-center justify-center">
                Loading editor...
            </div>
        )
    }

    const { CKEditor, ClassicEditor } = editor

    return (
        <>
            <CKEditor
                editor={ClassicEditor}
                config={{
                    toolbar: [
                        'heading',
                        '|',
                        'bold',
                        'italic',
                        'link',
                        'bulletedList',
                        'numberedList',
                        '|',
                        'outdent',
                        'indent',
                        '|',
                        'blockQuote',
                        'insertTable',
                        '|',
                        'undo',
                        'redo'
                    ],

                }}
                data={data}
                onChange={(event: any, editorInstance: any) => {
                    const editorData = editorInstance.getData()
                    onChange(editorData)
                }}
            />

            {/* Fix bullets/numbers being cut off */}
            <style jsx global>{`
        .ck-content ul,
        .ck-content ol {
          padding-left: 1.5em !important;
          margin-left: 0 !important;
        }

        .ck-content li {
          list-style-position: outside !important;
        }
      `}</style>
        </>
    )
}
