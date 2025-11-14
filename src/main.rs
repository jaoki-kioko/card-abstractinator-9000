use bevy::prelude::*;

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, setup)
        .run();
}
/// code altered from: https://bevy.org/examples/3d-rendering/3d-scene/
/// set up a simple 3D scene
fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    let boardwidth: f32 = 4.0;
    // circular base
    commands.spawn((
        Mesh3d(meshes.add(Circle::new(boardwidth))),
        MeshMaterial3d(materials.add(Color::srgb_u8(135, 135, 135))),
        Transform::from_rotation(Quat::from_rotation_x(-std::f32::consts::FRAC_PI_2)),
    ));

    // hand
    // cards are 5:7
    let width: f32 = 1.0; //.05*2
    let height: f32 = 0.01;
    let length: f32 = 1.4; // .07*2
    let cards: i32 = 2;

    for n in 1..=cards {
        let nf = n as f32;
        let cardsf = cards as f32;
        let center: f32 = (0.0-(((cardsf+1.0)*(width/2.0))))/2.0+(nf*(width/2.0));
        let stack: f32 = 0.0+(nf*height);

        commands.spawn((
            Mesh3d(meshes.add(Cuboid::new(width, height, length))),
            MeshMaterial3d(materials.add(Color::WHITE)),
            Transform::from_xyz(center, stack, 3.0),
        ));
    }


    // light
    commands.spawn((
        PointLight {
            shadows_enabled: true,
            ..default()
        },
        Transform::from_xyz(4.0, 8.0, 4.0),
    ));

    // camera
    commands.spawn((
        Camera3d::default(),
        Transform::from_xyz(0.0, 2.0, 7.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));
}

