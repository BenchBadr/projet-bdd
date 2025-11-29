const Profile = ({data}) => {
    console.log(data)
    return (
        <div className="profile">
        <img src={`/assets/none.png`}/>
        <div className="text-content">
            <div className="title">{data.nom}{` `}
                <a>{data.prenom}</a>
            </div>
            <div className="username">@{data.idprofil}</div>
        </div>
        </div>
    )
}

export default Profile;