enum Turn {
    LEFT, RIGHT;
}

/*
* Sets a key of a player based on direction and updates a button text to show current key.
* Called only if button has focus and if key is pressed. Checks if key is available and updates player based on direction.
*/
private void setPlayerKeys(Player player, GButton button, Turn direction) {
    char wishedKey = Character.toUpperCase(key);
    String keyStr = wishedKey + "";
    
    if (button.hasFocus()) {
        if(key == CODED) {
            switch(keyCode) {
                case LEFT:    button.setText("LEFT");
                              break;
                case RIGHT:   button.setText("RIGHT");
                              break;
                case UP:      button.setText("UP");
                              break;
                case DOWN:    button.setText("DOWN");
                              break;
                case ALT:     button.setText("ALT");
                              break;
                case CONTROL: button.setText("CTRL");
                              break;
                case SHIFT:   button.setText("SHIFT");
                              break;
            }
            if(isAvailable((char)keyCode)) {
                if(direction == Turn.LEFT) player.setLeft((char)keyCode);
                else player.setRight((char)keyCode);
                button.setFocus(false);
            } else {
                button.setText("Zauzeto!");
            }
        } else if(isAvailable(wishedKey)) {
            if(key == BACKSPACE) {
                button.setText("BACKSPACE");
            } else if(key == TAB) {
                button.setText("TAB");
            } else if(key == ENTER) {
                button.setText("ENTER");
            } else if(key == RETURN) {
                button.setText("RETURN");
            } else if(key == DELETE) {
                button.setText("DELETE");
            } else {
                button.setText(keyStr);
            }
            if(direction == Turn.LEFT) player.setLeft(wishedKey);
            else player.setRight(wishedKey);
            button.setFocus(false);
        } else {
            button.setText("Zauzeto!");
        }
    }
}

/*
* Checks if any player already uses wished key.
* Returns whether wished key is available or not.
*/
private boolean isAvailable(char wishedKey) {
    for(Player p : listOfPlayers) {
        if(p.getLeft() == wishedKey || p.getRight() == wishedKey) {
            return false;
        }
    }
    return true;
}

/*
* Checks if players left or right key was pressed.
* Adjusts the player's direction.
*/
private void checkIfKeysPressed(Player p) {
    if(p.isLeftPressed()) {
        p.setDirection(p.getDirection() + PI/15);
    }
    if(p.isRightPressed()) {
        p.setDirection(p.getDirection() - PI/15);
    }
}