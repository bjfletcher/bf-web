const fs = require('fs');
const Remarkable = require('remarkable');
const data = require('./data');
const Handlebars = require('handlebars');
const moment = require('moment');

const md = new Remarkable();

fs.readFile(`${__dirname}/article.hbs`, 'utf-8', (err, raw) => {
	const template = Handlebars.compile(raw);
	data.filter((item) => item.status === 'PUBLISHED').forEach((item) => {
		fs.readFile(`${__dirname}/data/${item.id}.md`, 'utf-8', (err, content) => {
			const description = content.substr(0, content.indexOf(item.previewTo) + item.previewTo.length) + '…';
			const templated = template({
				title: `${item.title} - Ben Fletcher`,
				description: description,
				id: item.id,
				type: 'article',
				articleTitle: item.title,
				articleDate: moment(item.date).format('D MMMM Y'),
				content: md.render(content),
				schema: JSON.stringify({
					'@context': "http://schema.org",
					'@type': "Article",
					url: "http://www.bbc.co.uk/news/uk-politics-38641208",
					publisher: {
							'@type': "Person",
							name: "Ben Fletcher",
							logo: 'https://www.benfletcher.com/img/mugshot.png'
					},
					headline: item.title,
					mainEntityOfPage: `https://www.benfletcher.com/${item.id}`,
					articleBody: description,
					datePublished: item.date
				})
			});
			const path = `${__dirname}/../static/${item.path.toLowerCase()}`;
			fs.mkdir(path, () => {
				fs.writeFile(`${path}/index.html`, templated);
			});
		});
	});
});