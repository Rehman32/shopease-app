const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const sendEmail = require('./utils/mailer');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.post('/order/placed', async (req, res) => {
  const { email, name, orderId } = req.body;

  await sendEmail({
    to: email,
    subject: '🛒 Order Confirmation – Thank You for Your Purchase!',
    text: `Hi ${name}, your order #${orderId} has been placed successfully.`,
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
        <h2 style="color: #4CAF50;">Thank you for your order, ${name}!</h2>
        <p>Your order <strong>#${orderId}</strong> has been placed successfully. We're preparing it for shipment.</p>
        
        <h3 style="margin-top: 30px;">What's next?</h3>
        <ul>
          <li>📦 We’ll notify you when your order is shipped.</li>
          <li>🕓 Estimated delivery time: 3-5 business days</li>
        </ul>

        <hr style="margin: 20px 0;">

        <p>If you have any questions or need support, feel free to contact our team at 
          <a href="mailto:support@ShopEase.com">support@fitconnect.com</a>.
        </p>

        <p>Thank you for choosing <strong>ShopEase</strong> </p>

        <p style="font-size: 12px; color: #888;">This is an automated email, please do not reply.</p>
      </div>
    `
  });

  res.status(200).json({ message: 'Order email sent' });
});

app.post('/order/status-update', async (req, res) => {
  const { email, name, orderId, status } = req.body;

  await sendEmail({
    to: email,
    subject: `Order Status Update - ShopEase 📦`,
    text: `Hi ${name}, your order #${orderId} status has been updated to: ${status}`,
    html: `<p>Hi <strong>${name}</strong>,</p><p>Your order <strong>#${orderId}</strong> status is now <strong>${status}</strong>.</p>`,
  });

  res.status(200).json({ message: 'Status update email sent' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Email service running on port ${PORT}`));
