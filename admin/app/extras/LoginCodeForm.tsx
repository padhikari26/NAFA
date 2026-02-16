import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { Card, CardHeader, CardTitle, CardContent } from '../../components/ui/card';
import { Button } from '../../components/ui/button';
import { KeyRound } from 'lucide-react';

export default function LoginCodeForm({ onClose, currentLoginCode, loading }: { onClose: () => void; currentLoginCode: string; loading?: boolean }) {
    const [loginCode, setLoginCode] = useState(currentLoginCode || '');
    const dispatch = useDispatch();
    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        dispatch({ type: 'CREATE_LOGIN_CODE_REQUEST', payload: { code: loginCode } });
    };
    return (
        <form onSubmit={handleSubmit} className="space-y-4">
            <Card>
                <CardContent>
                    <label className="block mb-2 font-medium"> Authorization Code</label>
                    <input
                        type="text"
                        value={loginCode}
                        onChange={e => setLoginCode(e.target.value)}
                        placeholder="Enter new authorization code"
                        className="border p-2 rounded w-full"
                        required
                        disabled={loading}
                    />
                </CardContent>
            </Card>
            <div className="flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={onClose} disabled={loading}>Cancel</Button>
                <Button type="submit" className="bg-nepal-blue hover:bg-nepal-blue/90" disabled={loading}>
                    {loading ? 'Updating...' : 'Update'}
                </Button>
            </div>
        </form>
    );
}
