const commands = {};
const commandList = [];

const openCommandBox = () => {
	const input = prompt('Enter a command:');
	if (!input) return;

	const args = input.split(' ');
	if (args.length < 1) return;

	const command = commands[args[0].toLowerCase()];
	if (!command) return;

	command._func(...args.slice(1));
};

class Command {
	constructor(name, desc, func) {
		this._name = name;
		this._func = func;
		this._originBind = null;
		this._bind = null;
		this._desc = desc;

		commandList.push({ name: name, info: desc });
		commands[name] = this;
	};
};

(() => {
	new Command('cmds', () => {
		const commandInfo = commandList.map(cmd => `${cmd.name} - ${cmd.info}`).join('\n');
		alert(commandInfo || 'Something should be here.');
	});
})();

(() => {
	let keysPressed = { ShiftRight: false, Slash: false };

	const onKeyDown = (event) => {
		if (event.code in keysPressed) keysPressed[event.code] = true;

		if (keysPressed['ShiftRight'] && keysPressed['Slash']) {
			openCommandBox();
			keysPressed['ShiftRight'] = false;
			keysPressed['Slash'] = false;
		};
	};

	const onKeyUp = (event) => {
		if (event.code in keysPressed) keysPressed[event.code] = false;
	};

	document.addEventListener('keydown', onKeyDown);
	document.addEventListener('keyup', onKeyUp);
})();
