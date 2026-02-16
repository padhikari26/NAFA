"use client"

import { useState } from "react"
import { Button } from "../../components/ui/button"
import { Card, CardHeader, CardTitle, CardContent } from "../../components/ui/card"
import BannerContent from "./BannerContent"
import LoginCodeContent from "./LoginCodeContent"
import ChangePasswordContent from "./ChangePasswordContent"

export default function ExtrasContent() {
    const [activeTab, setActiveTab] = useState<"logincode" | "banner" | "changepassword">("logincode")

    return (
        <div className="space-y-6">
            <Card>
                <CardHeader>
                    <CardTitle className="text-nepal-blue">Extras Management</CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="flex gap-2 mb-6">
                        <Button
                            variant={activeTab === "logincode" ? "default" : "outline"}
                            onClick={() => setActiveTab("logincode")}
                            className={
                                activeTab === "logincode"
                                    ? "bg-nepal-blue hover:bg-nepal-blue/90"
                                    : "border-nepal-blue text-nepal-blue hover:bg-nepal-blue/10"
                            }
                        >
                            Authorization Code
                        </Button>
                        <Button
                            variant={activeTab === "banner" ? "default" : "outline"}
                            onClick={() => setActiveTab("banner")}
                            className={
                                activeTab === "banner"
                                    ? "bg-nepal-blue hover:bg-nepal-blue/90"
                                    : "border-nepal-blue text-nepal-blue hover:bg-nepal-blue/10"
                            }
                        >
                            Banner
                        </Button>
                        <Button
                            variant={activeTab === "changepassword" ? "default" : "outline"}
                            onClick={() => setActiveTab("changepassword")}
                            className={
                                activeTab === "changepassword"
                                    ? "bg-nepal-blue hover:bg-nepal-blue/90"
                                    : "border-nepal-blue text-nepal-blue hover:bg-nepal-blue/10"
                            }
                        >
                            Change Password
                        </Button>
                    </div>

                    {activeTab === "logincode" && <LoginCodeContent />}
                    {activeTab === "banner" && <BannerContent />}
                    {activeTab === "changepassword" && <ChangePasswordContent />}
                </CardContent>
            </Card>
        </div>
    )
}
