

const MapPreview = ({ coords, zoom = 14 }) => {

const [coord_x, coord_y] = coords.split(',').map(s => parseFloat(s.trim()));

    const latLonToTile = (lat, lon, z) => {
    const x = Math.floor(((lon + 180) / 360) * Math.pow(2, z));
    const y = Math.floor(
        ((1 -
        Math.log(Math.tan((lat * Math.PI) / 180) + 1 / Math.cos((lat * Math.PI) / 180)) /
            Math.PI) /
        2) *
        Math.pow(2, z)
    );
    return { x, y };
    };

    const { x, y } = latLonToTile(coord_x, coord_y, zoom);
    const tileUrl = `https://tile.openstreetmap.org/${zoom}/${x}/${y}.png`;

    return (
    <div className="map-container">
        <img
        src={tileUrl}
        />
    </div>
    );
};



export default MapPreview;
