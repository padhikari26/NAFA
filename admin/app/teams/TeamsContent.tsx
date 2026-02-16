"use client"

import type React from "react"
import { useEffect, useState } from "react"
import { useDispatch, useSelector } from "react-redux"
import { TeamType } from "../../lib/types"
import AddUpdateTeamForm from "./AddUpdateTeamForm"
import type { RootState } from "@/lib/redux/store"
import { Plus, Users, Edit, Badge } from "lucide-react"
import imageUrl from "@/lib/helpers/baseUrls"
import ModalDialogWrapper from "../../components/ModalDialogWrapper"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

const TEAM_TABS = [
    { label: "Executive", value: TeamType.EXECUTIVE },
    { label: "Advisory", value: TeamType.ADVISORY },
    { label: "Past Executive", value: TeamType.PASTEXECUTIVE },
]

const TeamsContent: React.FC = () => {
    const dispatch = useDispatch()
    const [activeTab, setActiveTab] = useState<TeamType>(TeamType.EXECUTIVE)
    const [showForm, setShowForm] = useState(false)
    const [editData, setEditData] = useState<any>(null)

    const { teams, loading, createUpdateSuccess } = useSelector((state: RootState) => state.teamsReducer)
    const filteredTeams = Array.isArray(teams) ? teams.filter((team: any) => team.type === activeTab) : []

    useEffect(() => {
        dispatch({ type: "FETCH_TEAMS_REQUEST", payload: {} })
    }, [])

    useEffect(() => {
        const teamForTab = Array.isArray(teams) ? teams.find((team: any) => team.type === activeTab) : undefined
        setEditData(teamForTab || null)
    }, [teams, activeTab])

    useEffect(() => {
        if (createUpdateSuccess) {
            setShowForm(false)
            setEditData(null)
            dispatch({ type: "FETCH_TEAMS_REQUEST", payload: {} })
        }
    }, [createUpdateSuccess])

    return (
        <div className="space-y-6">
            <Card className="border-0 shadow-sm">
                <CardContent className="pt-6">
                    <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                        <div>
                            <h1 className="text-2xl font-bold nepal-blue">Teams Management</h1>
                            <p className="text-gray-600 mt-1">Manage executive, advisory, and past executive teams</p>
                        </div>
                        <Button onClick={() => setShowForm(true)} className="bg-nepal-red hover:bg-nepal-red/90 text-white" disabled={loading}>
                            <Plus className="mr-2 h-4 w-4" />
                            {editData && (editData as any).type === activeTab ? "Edit Team" : "Add Team"}
                        </Button>
                    </div>
                </CardContent>
            </Card>

            <ModalDialogWrapper
                open={showForm}
                setOpen={setShowForm}
                title={editData && (editData as any).type === activeTab ? 'Edit Team' : 'Create New Team'}
                subTitle='Manage team details and associated media'
            >
                <AddUpdateTeamForm
                    onClose={() => setShowForm(false)}
                    isEdit={!!editData && (editData as any).type === activeTab}
                    teamData={editData && (editData as any).type === activeTab ? editData : null}
                    teamType={activeTab}
                />
            </ModalDialogWrapper>

            <Card className="border shadow-sm">
                <CardContent className="pt-6">
                    <div className="flex gap-2 mb-4">
                        {TEAM_TABS.map((tab) => (
                            <Button
                                key={tab.value}
                                variant={activeTab === tab.value ? "default" : "outline"}
                                className={
                                    activeTab === tab.value
                                        ? "bg-nepal-blue hover:bg-nepal-blue/90 text-white"
                                        : "border-gray-300 hover:bg-gray-50"
                                }
                                onClick={() => {
                                    setActiveTab(tab.value)
                                    const teamForTab = Array.isArray(teams)
                                        ? teams.find((team: any) => team.type === tab.value)
                                        : undefined
                                    setEditData(teamForTab || null)
                                }}
                            >
                                {tab.label}
                            </Button>
                        ))}
                    </div>
                </CardContent>
            </Card>

            <Card className="border shadow-sm">
                <CardContent className="pt-6">
                    {loading ? (
                        <div className="flex justify-center items-center py-12">
                            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-nepal-blue"></div>
                            <span className="ml-3 text-gray-600">Loading teams...</span>
                        </div>
                    ) : (
                        <div className="space-y-4">
                            {filteredTeams.length === 0 ? (
                                <div className="text-center py-12">
                                    <div className="text-gray-400 mb-2">
                                        <Users className="h-12 w-12 mx-auto" />
                                    </div>
                                    <p className="text-gray-600 text-lg">No teams found</p>
                                    <p className="text-gray-500 text-sm">Create your first team to get started</p>
                                </div>
                            ) : (
                                filteredTeams.map((team: any) => (
                                    <Card
                                        key={team._id}
                                        className="border border-gray-200 hover:shadow-md transition-shadow duration-200"
                                    >
                                        <CardContent className="p-6">
                                            <div className="flex flex-col md:flex-row justify-between items-start gap-4">
                                                <div className="flex-1">
                                                    <div
                                                        dangerouslySetInnerHTML={{ __html: team.content }}
                                                        className="text-gray-700 leading-relaxed prose prose-sm max-w-none"
                                                    />
                                                </div>
                                                <div className="flex flex-col sm:flex-row gap-3 items-center">
                                                    {team.media && team.media.length > 0 && (
                                                        <div className="flex gap-2">
                                                            {team.media.slice(0, 3).map((img: any, index: number) => (
                                                                <div key={img.path} className="relative">
                                                                    <img
                                                                        src={imageUrl + img.path || "/placeholder.svg"}
                                                                        alt="team"
                                                                        className="w-16 h-16 object-cover rounded-lg border-2 border-gray-200 shadow-sm"
                                                                    />
                                                                    {index === 2 && team.media.length > 3 && (
                                                                        <div className="absolute inset-0 bg-black/50 rounded-lg flex items-center justify-center">
                                                                            <span className="text-white text-xs font-medium">+{team.media.length - 3}</span>
                                                                        </div>
                                                                    )}
                                                                </div>
                                                            ))}
                                                        </div>
                                                    )}
                                                    <Button
                                                        variant="outline"
                                                        className="border-nepal-red text-nepal-red hover:bg-nepal-red hover:text-white transition-colors bg-transparent"
                                                        onClick={() => {
                                                            setEditData(team)
                                                            setShowForm(true)
                                                        }}
                                                    >
                                                        <Edit className="mr-2 h-4 w-4" />
                                                        Edit
                                                    </Button>
                                                </div>
                                            </div>
                                        </CardContent>
                                    </Card>
                                ))
                            )}
                        </div>
                    )}
                </CardContent>
            </Card>
        </div>
    )
}

export default TeamsContent
