#!/bin/bash

echo "=== KeepassXC Integration Setup for Spotifyd ==="
echo
echo "To integrate KeepassXC with Spotifyd, follow these steps:"
echo
echo "1. Create a Spotify entry in your KeepassXC database:"
echo "   - Open KeepassXC"
echo "   - Create a new entry titled 'Spotify'"
echo "   - Set the username to your Spotify username"
echo "   - Set the password to your Spotify password"
echo
echo "2. Update the spotifyd configuration:"
echo "   - Edit ~/.config/spotifyd/spotifyd.conf"
echo "   - Replace YOUR_SPOTIFY_USERNAME with your actual username"
echo "   - Update the password_cmd line with your KeepassXC database path"
echo
echo "3. Test the KeepassXC integration:"
echo "   keepassxc-cli show -s -a password /path/to/your/database.kdbx Spotify"
echo
echo "4. Alternative: Use a wrapper script for better security:"
echo "   Create a script that handles the KeepassXC unlock and password retrieval"
echo
echo "Example wrapper script content:"
echo "#!/bin/bash"
echo "# Save this as ~/.local/bin/spotify-password"
echo "keepassxc-cli show -s -a password ~/path/to/your/database.kdbx Spotify"
echo
echo "Then update spotifyd.conf to use:"
echo "password_cmd = \"~/.local/bin/spotify-password\""
echo
echo "=== End of Setup Instructions ==="
