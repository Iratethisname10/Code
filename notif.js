const sendNotif = (text, time) => {
	const notif = document.createElement('div');
	notif.textContent = text;

	notif.style.position = 'fixed';
	notif.style.right = '20px';
	notif.style.top = '20px';
	notif.style.padding = '15px';
	notif.style.backgroundColor = '#333';
	notif.style.color = '#fff';
	notif.style.borderRadius = '5px';
	notif.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.5)';
	notif.style.zIndex = '1000';
	notif.style.opacity = '0';
	notif.style.transition = 'opacity 0.5s, top 0.5s';

	document.body.appendChild(notif);

	setTimeout(() => {
		notif.style.opacity = '1';
		notif.style.top = '30px';
	}, 10);

	setTimeout(() => {
		notif.style.opacity = '0';
		notif.style.top = '20px';

		setTimeout(() => {
			document.body.removeChild(notif);
		}, 500);
	}, time ? time : 3 * 1000);
};
