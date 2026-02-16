/** @format */

import React from "react";

interface Props {
    tipText: string;
    isSpinning: boolean;
    children: React.ReactNode;
}

const LoadingSpinner = ({ tipText, children, isSpinning = false }: Props) => {
    return (
        <div className="relative">
            <div className={isSpinning ? "opacity-30 pointer-events-none" : ""}>
                {children}
            </div>

            {isSpinning && (
                <div className="absolute inset-x-0 top-[30vh] flex flex-col items-center z-50">
                    <div className="bg-white rounded-full p-3 shadow-md">
                        <div className="animate-spin rounded-full h-12 w-12 border-4 border-t-[#39a79e] border-r-transparent border-b-[#39a79e] border-l-transparent"></div>
                    </div>
                    <span className="text-gray-800 font-medium mt-3 bg-white px-4 py-1 rounded-full shadow-sm">
                        {tipText}...
                    </span>
                </div>
            )}
        </div>
    );
};

export default LoadingSpinner;
